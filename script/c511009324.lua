--Parasite Plant
function c511009324.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511009324.reg)
	c:RegisterEffect(e1)
--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10833828,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c511009324.spcon)
	e3:SetTarget(c511009324.sptg2)
	e3:SetOperation(c511009324.spop2)
	c:RegisterEffect(e3)
end
function c511009324.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(17330916,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c511009324.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(17330916)~=0
end
function c511009324.spfilter(c,e)
	return c:GetCode()==511002961 and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c511009324.spfilter2(c,e)
	return c:GetEquipGroup():IsExists(Card.IsCode,1,nil,511002961) and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c511009324.spfilter3(c,e,tp,m,g,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and g:IsExists(c511009324.spfilter4,1,nil,m,c,chkf)
end
function c511009324.spfilter4(c,m,fusc,chkf)
	return fusc:CheckFusionMaterial(m,c,chkf)
end
function c511009324.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c511009324.spfilter,tp,LOCATION_MZONE,0,nil,e)
		if g:GetCount()==0 then return false end
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local res=Duel.IsExistingMatchingCard(c511009324.spfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,g,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c511009324.spfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,g,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c511009324.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c511009324.spfilter,tp,LOCATION_MZONE,0,nil,e)
	g:Remove(Card.IsImmuneToEffect,nil,e)
	if g:GetCount()==0 then return false end
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c511009324.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	local sg1=Duel.GetMatchingGroup(c511009324.spfilter3,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,g,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c511009324.spfilter3,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,g,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local ec=g:FilterSelect(tp,c511009324.spfilter4,1,1,nil,mg1,tc,chkf):GetFirst()
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,ec,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local ec=g:FilterSelect(tp,c511009324.spfilter4,1,1,nil,mg2,tc,chkf):GetFirst()
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,ec,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
		--equip Pfusioner
		local sg=Duel.GetMatchingGroup(c511009324.eqfilter,tp,LOCATION_GRAVE,0,nil)
		local eqtc=sg:GetFirst()
		while eqtc do
			if not Duel.Equip(tp,eqtc,tc,false) then return end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c511009324.eqlimit)
			e1:SetLabelObject(tc)
			eqtc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(300)
			eqtc:RegisterEffect(e2)
			eqtc=sg:GetNext()
		end
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCode(EFFECT_IMMUNE_EFFECT)
		e5:SetValue(c511009324.efilter)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e5)
	end
end
function c511009324.eqfilter(c)
	return c:GetCode()==511002961 and c:IsType(TYPE_MONSTER)
end
function c511009324.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c511009324.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end