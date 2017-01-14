--真竜機兵ダースメタトロン
--True Draco Da'at Metatron, the Mechsoldier
--Script by nekrozar
function c100912025.initial_effect(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c100912025.ttcon)
	e1:SetOperation(c100912025.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c100912025.setcon)
	c:RegisterEffect(e2)
	--tribute check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c100912025.valcheck)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c100912025.efilter)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(100912025,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c100912025.spcon)
	e5:SetTarget(c100912025.sptg)
	e5:SetOperation(c100912025.spop)
	c:RegisterEffect(e5)
end
function c100912025.otfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and not c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c100912025.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.CheckTribute then
		local mg=Duel.GetMatchingGroup(c100912025.otfilter,tp,LOCATION_ONFIELD,0,nil)
		return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=3)
			or (Duel.CheckTribute(c,1) and mg:GetCount()>=2)
			or (Duel.CheckTribute(c,2) and mg:GetCount()>=1)
			or (Duel.CheckTribute(c,3))
	else
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local mg=Duel.GetMatchingGroup(c100912025.otfilter,tp,LOCATION_ONFIELD,0,nil)
		if ft<=0 and Duel.GetTributeCount(c)<=0 then return false end
		return ft>-3 and Duel.GetTributeCount(c)+mg:GetCount()>=3
	end
end
function c100912025.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c100912025.otfilter,tp,LOCATION_ONFIELD,0,nil)
	local ct=3
	local g=Group.CreateGroup()
	if Duel.GetTributeCount(c)<ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=mg:Select(tp,ct-Duel.GetTributeCount(c),ct-Duel.GetTributeCount(c),nil)
		g:Merge(g2)
		mg:Sub(g2)
		ct=ct-g2:GetCount()
	end
	if ct>0 and Duel.GetTributeCount(c)>=ct and mg:GetCount()>0
		and Duel.SelectYesNo(tp,aux.Stringid(100912025,0)) then
		local ect=ct
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then ect=ect-1 end
		ect=math.min(mg:GetCount(),ect)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g3=mg:Select(tp,1,ect,nil)
		g:Merge(g3)
		ct=ct-g3:GetCount()
	end
	if ct>0 then
		local g4=Duel.SelectTribute(tp,c,ct,ct)
		g:Merge(g4)
	end
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c100912025.setcon(e,c,minc)
	if not c then return true end
	return false
end
function c100912025.valcheck(e,c)
	local g=c:GetMaterial()
	local typ=0
	local tc=g:GetFirst()
	while tc do
		typ=bit.bor(typ,bit.band(tc:GetOriginalType(),0x7))
		tc=g:GetNext()
	end
	e:SetLabel(typ)
end
function c100912025.efilter(e,te)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
		and te:IsActiveType(e:GetLabelObject():GetLabel()) and te:GetOwner()~=e:GetOwner()
end
function c100912025.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and bit.band(c:GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
end
function c100912025.spfilter(c,e,tp)
	return c:IsAttribute(0xf) and c:IsType(0x802040) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100912025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100912025.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100912025.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100912025.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end