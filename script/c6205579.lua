--パラサイト・フュージョナー
--Parasite Fusioner
--Scripted by Eerie Code
function c6205579.initial_effect(c)
	--Auxiliary changes
	function Auxiliary.ParasiteFilter(f)
		return function(c)
			return f(c) and not c:IsHasEffect(6205579)
		end
	end
	function Auxiliary.AddFusionProcCodeFun(c,code1,f,cc,sub,insf)
		if c:IsStatus(STATUS_COPYING_EFFECT) then return end
		if c.material_count==nil then
			local code=c:GetOriginalCode()
			local mt=_G["c" .. code]
			mt.material_count=1
			mt.material={code1}
		end
		f=Auxiliary.ParasiteFilter(f)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_FUSION_MATERIAL)
		e1:SetCondition(Auxiliary.FConditionCodeFun(code1,f,cc,sub,insf))
		e1:SetOperation(Auxiliary.FOperationCodeFun(code1,f,cc,sub,insf))
		c:RegisterEffect(e1)
	end
	function Auxiliary.AddFusionProcFun2(c,f1,f2,insf)
		f1=Auxiliary.ParasiteFilter(f1)
		f2=Auxiliary.ParasiteFilter(f2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_FUSION_MATERIAL)
		e1:SetCondition(Auxiliary.FConditionFun2(f1,f2,insf))
		e1:SetOperation(Auxiliary.FOperationFun2(f1,f2,insf))
		c:RegisterEffect(e1)
	end
	function Auxiliary.AddFusionProcFunRep(c,f,cc,insf)
		f=Auxiliary.ParasiteFilter(f)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_FUSION_MATERIAL)
		e1:SetCondition(Auxiliary.FConditionFunRep(f,cc,insf))
		e1:SetOperation(Auxiliary.FOperationFunRep(f,cc,insf))
		c:RegisterEffect(e1)
	end
	function Auxiliary.AddFusionProcFunFunRep(c,f1,f2,minc,maxc,insf)
		f1=Auxiliary.ParasiteFilter(f1)
		f2=Auxiliary.ParasiteFilter(f2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_FUSION_MATERIAL)
		e1:SetCondition(Auxiliary.FConditionFunFunRep(f1,f2,minc,maxc,insf))
		e1:SetOperation(Auxiliary.FOperationFunFunRep(f1,f2,minc,maxc,insf))
		c:RegisterEffect(e1)
	end
	function Auxiliary.AddFusionProcCodeFunRep(c,code1,f,minc,maxc,sub,insf)
		if c:IsStatus(STATUS_COPYING_EFFECT) then return end
		if c.material_count==nil then
			local code=c:GetOriginalCode()
			local mt=_G["c" .. code]
			mt.material_count=1
			mt.material={code1}
		end
		f=Auxiliary.ParasiteFilter(f)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_FUSION_MATERIAL)
		e1:SetCondition(Auxiliary.FConditionFunFunRep(Auxiliary.FilterBoolFunctionCFR(code1,sub,c),f,minc,maxc,insf))
		e1:SetOperation(Auxiliary.FOperationFunFunRep(Auxiliary.FilterBoolFunctionCFR(code1,sub,c),f,minc,maxc,insf))
		c:RegisterEffect(e1)
	end
	if not c6205579.global_flag then
		c6205579.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(c6205579.adjust)
		Duel.RegisterEffect(ge1,0)
	end

	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6205579,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c6205579.sptg)
	e1:SetOperation(c6205579.spop)
	c:RegisterEffect(e1)
	--fusion substitute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e2:SetCondition(c6205579.subcon)
	c:RegisterEffect(e2)
	--must be substitute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(6205579)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	c:RegisterEffect(e3)
end

function c6205579.subcon(e)
	return e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end

function c6205579.spfilter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c6205579.spfilter2(c,e,tp,m,f,gc)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc)
end
function c6205579.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg1=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_MZONE,0,c)
		local res=Duel.IsExistingMatchingCard(c6205579.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c6205579.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,c)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c6205579.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	local mg1=Duel.GetMatchingGroup(c6205579.spfilter1,tp,LOCATION_MZONE,0,c,e)
	local sg1=Duel.GetMatchingGroup(c6205579.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c6205579.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,c)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,c)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end

--Adjustment for cards with particular procedures
function c6205579.adjust(e,tp,eg,ep,ev,re,r,rp)
	local mt
	--メタルフォーゼ・オリハルク (Metalfoes Orichalc)
	if c28016193 then
		mt=c28016193
		mt.filter=function(c) return c:IsFusionSetCard(0xe1) and not c:IsHasEffect(6205579) end
	end
	--メタルフォーゼ・ミスリエル (Metalfoes Mithriel)
	if c4688231 then
		mt=c4688231
		mt.filter1=function(c) return c:IsFusionSetCard(0xe1) and not c:IsHasEffect(6205579) end
	end
	--メタルフォーゼ・カーディナル (Metalfoes Crimsonite)
	if c54401832 then
		mt=c54401832
		mt.filter1=function(c) return c:IsFusionSetCard(0xe1) and not c:IsHasEffect(6205579) end
		mt.filter2=function(c) return c:IsAttackBelow(3000) and not c:IsHasEffect(6205579) end
	end
	--ワーム・ゼロ (Worm Zero)
	if c74506079 then
		mt=c74506079
		mt.ffilter=function(c) return c:IsFusionSetCard(0x3e) and c:IsRace(RACE_REPTILE) and not c:IsHasEffect(6205579) end
	end
	--フルメタルフォーゼ・アルカエスト (Fullmetalfoes Alkahest)
	if c77693536 then
		mt=c77693536
		mt.filter1=function(c) return c:IsFusionSetCard(0xe1) and not c:IsHasEffect(6205579) end
	end
	--メタルフォーゼ・アダマンテ (Metalfoes Adamante)
	if c81612598 then
		mt=c81612598
		mt.filter1=function(c) return c:IsFusionSetCard(0xe1) and not c:IsHasEffect(6205579) end
		mt.filter2=function(c) return c:IsAttackBelow(2500) and not c:IsHasEffect(6205579) end
	end
	--キメラテック・ランページ・ドラゴン (Chimeratech Rampage Dragon)
	if c84058253 then
		mt=c84058253
		mt.ffilter=function(c) return c:IsFusionSetCard(0x1093) and not c:IsHasEffect(6205579) end
	end
end