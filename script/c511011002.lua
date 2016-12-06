--Crest Burn
--scripted by Keddy
function c511011002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(511011002)
	e1:SetTarget(c511011002.target)
	e1:SetOperation(c511011002.activate)
	c:RegisterEffect(e1)
	if not c511011002.global_check then
		c511011002.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		ge1:SetOperation(c511011002.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c511011002.cfilter(c,tp)
	return c:IsCode(100000370) and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_DESTROY) and c:IsControler(tp) 
		and c:GetPreviousControler()==tp
end
function c511011002.filter(c)
	return c:IsFaceup() and c:IsCode(111215001)
end
function c511011002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ev>0 and Duel.IsExistingMatchingCard(c511011002.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0x1110,ev)
end
function c511011002.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=ev
	local g=Duel.GetMatchingGroup(c511011002.filter,tp,LOCATION_ONFIELD,0,nil)
	if g:GetCount()<=0 then return end
	if g:GetCount()==1 then
		local sc=Duel.GetFirstMatchingCard(c511011002.filter,tp,LOCATION_ONFIELD,0,nil)
		Duel.HintSelection(Group.FromCards(sc))
		sc:AddCounter(0x1110,ct)
	else
		while g:GetCount()>1 and ct>0 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local sg=g:Select(tp,1,1,nil)
			local sc=sg:GetFirst()
			local t={}
			local i=1
			for i=1,ct do 
				t[i]=i
			end
			local tempct=Duel.AnnounceNumber(tp,table.unpack(t))
			ct=ct-tempct
			Duel.HintSelection(sg)
			sc:AddCounter(0x1110,tempct)
			g:RemoveCard(sc)
		end
		if g:GetCount()==1 and ct>0 then
			local sc=g:GetFirst()
			Duel.HintSelection(Group.FromCards(sc))
			sc:AddCounter(0x1110,ct)
		end
	end
end
function c511011002.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c511011002.cfilter,nil,tp)
	local ct=0
	local tc=g:GetFirst()
	while tc do
		ct=ct+tc:GetCounter(0x95)
		tc=g:GetNext()
	end
	if re then
		Duel.RaiseEvent(g,511011002,re,r,rp,ep,ct)
	else
		Duel.RaiseEvent(g,511011002,e,r,rp,ep,ct)
	end
end
